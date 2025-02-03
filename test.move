// // Copyright (c) Mysten Labs, Inc.
// // SPDX-License-Identifier: Apache-2.0

// /// A simple user onboarding module that stores a hash of personal details
// /// (such as age, sex, height, weight, etc.) instead of the raw data.
// module user_onboarding::user_onboarding {
//     // use sui::object::{Self, UID};
//     use sui::hash;
//     // use sui::transfer;
//     // use std::vector;

//     /// A UserProfile holds a hashed version of the user's personal details.
//     /// The sensitive details are not stored directly but rather as a hash.
//     public struct UserProfile has key, store {
//         id: UID,
//         owner: address,
//         details_hash: vector<u8>,
//     }

//     /// Onboards a new user.
//     ///
//     /// The `data` vector should be a serialized representation of the user's personal details
//     /// (for example, "30,male,180,75"). The data is hashed using keccak256 and stored in the
//     /// UserProfile.
//     public fun onboard_user(data: vector<u8>, ctx: &mut TxContext) {
//         let hashed = hash::keccak256(&data);
//         let profile = UserProfile {
//             id: sui::object::new(ctx),
//             owner: ctx.sender(),
//             details_hash: hashed,
//         };
//         transfer::share_object(profile);
//     }

//     /// Updates the user's profile with new personal details.
//     ///
//     /// Only the profile owner (i.e. the sender) is authorized to update their profile.
//     public fun update_profile(profile: &mut UserProfile, new_data: vector<u8>, ctx: &TxContext) {
//         // Only the owner can update their profile.
//         assert!(profile.owner == ctx.sender(), 0);
//         let new_hashed = hash::keccak256(&new_data);
//         profile.details_hash = new_hashed;
//     }

//     /// Verifies that the provided data matches the stored details hash.
//     ///
//     /// Returns `true` if the hash of `data` equals the stored hash.
//     public fun verify_profile(profile: &UserProfile, data: vector<u8>): bool {
//         let computed_hash = hash::keccak256(&data);
//         computed_hash == profile.details_hash
//     }

//     ///////////////////////////////////////////////////////////////////////////
//     //                              TESTING                                  //
//     ///////////////////////////////////////////////////////////////////////////

//     #[test_only]
//     use sui::test_scenario as ts;

//     ///////////////////////////////////////////////////////////////////////////
//     // Test: Onboard a user and verify that the stored hash matches the data.
//     ///////////////////////////////////////////////////////////////////////////
//     #[test]
//     fun test_onboard_and_verify() {
//         // Begin a test scenario with sender @0xA.
//         let mut ts = ts::begin(@0xA);
//         ts::next_tx(&mut ts, @0xA);
//         // Sample personal details, for example: "30,male,180,75"
//         let data = b"30,male,180,75";
//         // Onboard the user (this computes the hash and shares the UserProfile).
//         onboard_user(data, ts::ctx(&mut ts));
//         // Retrieve the shared UserProfile object.
//         let profile: UserProfile = ts::take_from_sender(&ts);
//         // Verify that the stored hash matches the original data.
//         assert!(verify_profile(&profile, data), 0);
//         ts::return_to_sender(&ts, profile);
//         ts::end(ts);
//     }

//     ///////////////////////////////////////////////////////////////////////////
//     // Test: Update a user profile from the authorized sender.
//     ///////////////////////////////////////////////////////////////////////////
//     #[test]
//     fun test_update_profile_authorized() {
//         let mut ts = ts::begin(@0xA);
//         ts::next_tx(&mut ts, @0xA);
//         let data = b"30,male,180,75";
//         onboard_user(data, ts::ctx(&mut ts));
//         let mut profile: UserProfile = ts::take_from_sender(&ts);
//         // New personal details.
//         let new_data = b"35,female,170,65";
//         // Update the profile (authorized, since the sender is the owner).
//         update_profile(&mut profile, new_data, ts::ctx(&mut ts));
//         // Verify that the stored hash now matches the new data.
//         assert!(verify_profile(&profile, new_data), 0);
//         ts::return_to_sender(&ts, profile);
//         ts::end(ts);
//     }


// }
