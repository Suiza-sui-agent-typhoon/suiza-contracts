module move_to_earn::streak_rewards {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;
    use std::vector;

    // ========================================================
    // Constants
    // ========================================================

    /// Number of consecutive days required for a bonus reward.
    const REQUIRED_STREAK: u64 = 7;
    /// The amount (in SUI) awarded when the required streak is achieved.
    const REWARD_AMOUNT: u64 = 10;

    // ========================================================
    // Resources
    // ========================================================

    /// A StreakRecord holds the current daily check‑in streak for a user,
    /// along with the last day (simulated as a u64) the user checked in.
    public struct StreakRecord has key, store {
        id: UID,
        user: address,
        streak: u64,
        last_check_in: u64,
    }

    /// A RewardPool holds a coin balance of SUI that will be used to pay rewards.
    public struct RewardPool has key, store {
        id: UID,
        owner: address,
        balance: Coin<SUI>,
    }

    // ========================================================
    // Public Functions
    // ========================================================

    /// Initializes a new streak record for the caller.
    ///
    /// The record is initialized with a streak of 0 and a last_check_in value set to
    /// (start_day - 1). This way, when the user checks in on `start_day`, the streak becomes 1.
    public fun initialize_streak(start_day: u64, ctx: &mut TxContext) {
        let record = StreakRecord {
            id: sui::object::new(ctx),
            user: ctx.sender(),
            streak: 0,
            last_check_in: start_day - 1,
        };
        transfer::share_object(record);
    }

    /// Initializes a new reward pool with an initial balance.
    ///
    /// The caller becomes the owner of the pool.
    public fun initialize_reward_pool(initial_balance: Coin<SUI>, ctx: &mut TxContext): RewardPool {
        RewardPool {
            id: sui::object::new(ctx),
            owner: ctx.sender(),
            balance: initial_balance,
        }
    }

    /// Records a daily check‑in for the user.
    ///
    /// The `current_day` parameter simulates the current day (e.g., 1, 2, 3, …).
    /// - If `current_day` equals `last_check_in + 1`, the streak is incremented.
    /// - If more than one day has passed, the streak is reset to 1.
    /// - If `current_day` is not greater than `last_check_in`, the function aborts.
    public fun check_in(record: &mut StreakRecord, current_day: u64, ctx: &TxContext) {
        // Only the owner of the record may check in.
        assert!(record.user == ctx.sender(), 0);
        if (current_day == record.last_check_in + 1) {
            record.streak = record.streak + 1;
        } else if (current_day > record.last_check_in + 1) {
            // If one or more days are missed, restart the streak.
            record.streak = 1;
        } else {
            // A duplicate or out-of-order check‑in.
            assert!(false, 1);
        };
        record.last_check_in = current_day;
    }

    /// Claims a reward based on the user's current streak.
    ///
    /// Every time the user’s streak is a multiple of REQUIRED_STREAK (e.g., 7, 14, …),
    /// REWARD_AMOUNT SUI tokens are transferred from the reward pool to the user.
    public fun claim_reward(record: &StreakRecord, pool: &mut RewardPool, ctx: &mut TxContext) {
        // Only the owner of the record can claim a reward.
        assert!(record.user == ctx.sender(), 0);
        if (record.streak > 0 && record.streak % REQUIRED_STREAK == 0) {
            let pool_balance = sui::coin::value(&pool.balance);
            assert!(pool_balance >= REWARD_AMOUNT, 2);
            // let reward = sui::coin::extract(&mut pool.balance, REWARD_AMOUNT);
             let reward = coin::split(&mut pool.balance, REWARD_AMOUNT, ctx);
            transfer::public_transfer(reward, ctx.sender());
        }
    }
}
