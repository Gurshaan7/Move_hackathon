module my_addrx::MessagesCommucntion
{
    use std::string::{String,Self};
    use std::signer;
    use aptos_framework::account;
    use std::vector;

    struct Message has store
    {
        from: address,
        payload: vector<u8>
    }

    struct MessageStore has key
    {
        messages : vector<Message>
    }


    public entry fun create_store(account: &signer) 
    {
        let signer_address = signer::address_of(account);
        assert!( !exists<MessageStore>(signer_address) , 1);

        let ms = MessageStore{
            messages : vector::empty()
        };

        move_to(account , ms);

    }

    public entry fun send_message(from: &signer , to: address , msg: vector<u8>) acquires MessageStore
    {
   
        let ms = borrow_global_mut<MessageStore>(to);
        vector::push_back(&mut ms.messages, Message{
            from: signer::address_of(from),
            payload: msg
        });

    } 



}