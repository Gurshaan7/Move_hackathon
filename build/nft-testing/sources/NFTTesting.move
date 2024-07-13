module my_addrx::NFTTesting
{
    use std::signer;
    use aptos_framework::object; 
    use std::option;   
    use aptos_token_objects::collection; 
    use aptos_framework::object::ConstructorRef; 
    use std::string::{String,Self}; 
    use aptos_framework::account::SignerCapability;
    use aptos_framework::resource_account;
    use aptos_framework::account;
    use aptos_token_objects::token::{Self, Token};


     

    fun create_collection_helper(creator: &signer, collection_name: String   ) {
        // Creates a fixed-sized collection, or a collection that supports a fixed amount of tokens. 
        collection::create_unlimited_collection(
            creator, 
            string::utf8(b"Collection Description"),
            collection_name,
            option::none(), 
            string::utf8(b"Collection URL"),
        );
    }

    public entry fun init_module_(resource_signer: &signer) {
        create_collection_helper(resource_signer, string::utf8(b"")); 
    } 

    fun create_token_helper(creator: &signer, collection_name: String, token_name: String , data: String): ConstructorRef {
        // Creates a new token object with a unique address and returns the ConstructorRef for additional specialization.
        token::create(
            creator,
            collection_name,
            data,
            token_name,
            option::none(),
            string::utf8(b"Token URL"),
        )
    }
 
    public entry fun create_token(from: &signer , to: address , data: String)  {
       
        // Minting token 
        let token_name = string::utf8(b"Token Name");
        let cr = create_token_helper(from, string::utf8(b""), token_name , data);

        // Transferring token
        let token_addr = object::address_from_constructor_ref(&cr);
        let token = object::address_to_object<Token>(token_addr); 
        object::transfer(from, token, to); 
 
    }
}
