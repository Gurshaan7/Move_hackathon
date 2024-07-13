module my_addrx::NameService
{
    use std::string::{String, Self};
    use std::table;
    use std::signer;
    use std::option;

    const E_NAME_ALREADY_TAKEN: u64 = 100;
    struct NameServiceStore has key
    {
        registry: 0x1::table::Table<String, address>
    }


    fun init_module(admin: &signer)
    {
        assert!(signer::address_of(admin) == @my_addrx , 1);
        let r = NameServiceStore{registry: 0x1::table::new<String,address >()};
        move_to<NameServiceStore>(admin,r );
    }


    #[view]
    public fun get_address(user: String): option::Option<address> acquires NameServiceStore
    {
        let reg = borrow_global<NameServiceStore>(@my_addrx);

        if(table::contains(&reg.registry , user))
        {
            return option::some(*table::borrow(&reg.registry , user))
        }
        else
        {
            return option::none()
        }

    }

    public entry fun register_name(user: &signer, name: String) acquires NameServiceStore 
    {
        let reg = borrow_global_mut<NameServiceStore>(@my_addrx);
        

        if(table::contains(&reg.registry , name))
        {
            abort E_NAME_ALREADY_TAKEN
        }
        else
        {
            let user_address = signer::address_of(user);
            let registration_fees = 0x1::coin::withdraw<0x1::aptos_coin::AptosCoin>(user,100000); 
            0x1::aptos_account::deposit_coins(@my_addrx , registration_fees);
            table::add(&mut reg.registry, name, user_address);
        };
    } 
}