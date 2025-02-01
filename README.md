# suiza-contracts
Smart Contracts powering suiza agent in healthcare.

               +-----------------+
               |   User Device   |
               | (Mobile/Web App)|
               +--------+--------+
                        |
                        v
               +-----------------+       Fitbit/Wearable
               |   API Gateway   | <------------------+
               +--------+--------+                    |
                        |                             |
                        v                             |
            +-------------------------+              |
            |  Backend & Oracles      |              |
            | (Data Aggregation & AI) |              |
            +------------+------------+              |
                         |                           |
                         v                           |
             +---------------------------+          |
             |  Sui Blockchain Layer     |          |
             | +-----------------------+ |          |
             | |  User Profile Contract| |          |
             | |  Enrollment Contract  | |          |
             | |  Reward (Token) Logic | |          |
             | +-----------------------+ |          |
             +---------------------------+          |
                        ^                           |
                        |                           |
                        +---------------------------+
