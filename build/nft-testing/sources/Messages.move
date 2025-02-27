module my_addrx::Messages
{
    use std::string::{String,Self};
    use std::signer;
    use aptos_framework::account;
    
    struct Message has key
    {
        my_message : String
    }

    public entry fun  create_message(account: &signer, msg: String)  acquires Message{
        let signer_address = signer::address_of(account);
        
        if(!exists<Message>(signer_address))  //If the resource does not exits corresponding to a given address
        {
            let message = Message {
                my_message : msg             //first create a resouce
            };
            move_to(account,message);        //move that resouce to the account
        }

        else                                 //If the resource exits corresponding to a given address
        {
            let message = borrow_global_mut<Message>(signer_address); //get the resouce 
            message.my_message=msg;                                   //update the resouce
        }
        
    }

    #[view]
    public fun testing(signer_address: address) : String acquires Message
    {
        let message = borrow_global_mut<Message>(signer_address); //get the resouce 
        message.my_message  
    }


    #[test(admin = @0x123)]
    public entry fun test_flow(admin: signer) acquires Message 
    {
        account::create_account_for_test(signer::address_of(&admin));
        create_message(&admin,string::utf8(b"This is my message"));
        create_message(&admin,string::utf8(b"I changed my message"));
        
        let message=borrow_global<Message>(signer::address_of(&admin));
        assert!(message.my_message==string::utf8(b"I changed my message"),10);
    }

}