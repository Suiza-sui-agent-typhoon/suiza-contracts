module user_onboarding::user_onboarding {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::hash;
    use sui::transfer;
    use std::vector;

    /// A UserProfile holds a hashed version of the user's personal details.
    /// The sensitive details are not stored directly but rather as a hash.
    public struct UserProfile has key, store {
        id: UID,
        owner: address,
        details_hash: vector<u8>,
    }

    /// Onboards a new user.
    ///
    /// The `data` vector should be a serialized representation of the user's personal details
    /// (e.g., age, sex, height, weight, etc.). The data is hashed using keccak256 and stored
    /// in the UserProfile.
    public fun onboard_user(data: vector<u8>, ctx: &mut TxContext) {
        // Compute the hash of the provided data.
        let hashed = hash::keccak256(&data);
        // Create a new user profile with the hashed data.
        let profile = UserProfile {
            id: object::new(ctx),
            owner: ctx.sender(),
            details_hash: hashed,
        };
        // Transfer (share) the newly created profile object to the sender.
        transfer::share_object(profile);
    }

    /// Updates the user's profile with new personal details.
    ///
    /// Only the profile owner (i.e. the sender) is authorized to update their profile.
    public fun update_profile(profile: &mut UserProfile, new_data: vector<u8>, ctx: &TxContext) {
        // Ensure that the caller is the profile owner.
        assert!(profile.owner == ctx.sender(), 0);
        // Compute a new hash from the updated data.
        let new_hashed = hash::keccak256(&new_data);
        profile.details_hash = new_hashed;
    }

    /// Verifies that the provided data matches the stored details hash.
    ///
    /// Returns true if the hash of `data` equals the stored hash.
    public fun verify_profile(profile: &UserProfile, data: vector<u8>): bool {
        let computed_hash = hash::keccak256(&data);
        computed_hash == profile.details_hash
    }
}
