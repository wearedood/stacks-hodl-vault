# 🏦 Stacks HODL Vault (Nakamoto Ready)

A strictly Bitcoin-native, time-locked savings vault built explicitly for the Stacks Nakamoto Upgrade.

## 🎯 The Vision
Most DeFi protocols lock tokens based on easily manipulated timestamps or abstract network metrics. This vault enforces **true Bitcoin alignment**. It locks STX directly to the Bitcoin blockchain's `burn-block-height`. Your funds do not move until the Bitcoin network ticks forward.

## 🛠️ Tech Stack
* **Language:** Clarity 4
* **Framework:** Clarinet
* **Network:** Stacks Nakamoto (Ready)

## 🔐 Security & Features
* **Nakamoto Compliance:** Replaces deprecated `block-height` with strict `burn-block-height` tracking.
* **Clarity 4 Allowances:** Utilizes the new `as-contract?` built-in function to enforce strict STX spending allowances, preventing contract draining.
* **Trustless:** Completely decentralized. Only the original depositor can withdraw their specific funds once the target Bitcoin block is mined.

## 🚀 How It Works
1. **Lock:** User calls `lock`, sending STX to the vault and specifying a duration (in Bitcoin blocks).
2. **Hold:** The contract unconditionally rejects any withdrawal attempt before the target Bitcoin block is mined.
3. **Withdraw:** Once the target `burn-block-height` is reached, the user calls `withdraw` to retrieve their exact deposit.
