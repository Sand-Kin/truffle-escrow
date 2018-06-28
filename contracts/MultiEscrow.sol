pragma solidity ^0.4.23;

/*
@Title: MultiEscrow.
@dev: An escrow service that can be used for multiple separate actions simultaneously
@Author: Malcolm MacKay
*/

contract MultiEscrow {

    event new_transaction(uint transaction_id);

    uint init_fee = 0.001 ether; //prevents seller from overloading the
                                //system with transactions

    struct transaction {
        address buyer;
        address seller;
        uint price;
        uint balance; //possibly make uint 32 to save space?
        uint time_out;
        string active; //possibly make bytes32?
        string paid;   //possibly collapse strings into one single string, 
                        //e.g. NEW-> BUYERPAID -> SELLERPAID-> BOTHPAID-> CLOSED
    }

    transaction[] public transactions;
    //@dev
    // buyer has to know transaction ID- is that a mistake?
    // I don't think so, that way the buyer has control, they 
    // only have to pay for the transaction they choose


    //@dev: seller initiates and sets parameters for transaction. they also have to pay a fee
    function init_transaction(uint _price, address _buyer) external payable { 
        require(msg.value >= init_fee);
        uint id = transactions.push(transaction(_buyer, msg.sender, _price, init_fee, (now+30 days), "OPEN", "UNPAID")) -1;
        //TO ADD: send message to buyer
        emit new_transaction(id);
    }
    //@dev: buyer sends money into escrow. Once the required amount is in escrow, transaction is marked as paid
    function pay(uint _id) external payable {
        require(msg.sender == transactions[_id].buyer);
        transactions[_id].balance += msg.value;
        if (transactions[_id].balance >= transactions[_id].price){
            transactions[_id].paid = "PAID";
        }
        
    }
    function owed_balance(uint _id) external view returns(uint){
        require(msg.sender == transactions[_id].buyer);
        return transactions[_id].balance;
    }
    /*
    function claim(uint _id) external{
        if(now >= transactions[_id].time_out) { //if the transaction has timed out and the buyer wants to reclaim funds
        //shit someone could call this more than once
            if(msg.sender == transactions[_id].buyer){
                
            }
            if(msg.sender == transactions[_id].seller){

            }
            transactions[_id].active = "CLOSED"
        } 


    }
    */
    //function destroySelf onlyOnwer pure?
    //only let function destroy itself if 
    // all transactions are timed out 
}