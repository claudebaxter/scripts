#DCV2 Minting

This is the script used to mint Dark Coin V2, with a supply of 500,000,000 with an atomic unit of 6 decimal places (0.000001).

To use this script, you will need to add your purestake API key and mainnet or testnet url (use testnet first to be safe). 

Then you will need to add your wallet address and mnemonic passphrase (enter this as a series of words and spaces between "").

You will also need to configure the token name, unit name, circulating supply and decimals. Keep in mind you need to compensate in the total supply for the atomic unit. So for a circulating supply of 500,000,000 with an atomic unit of 0.000001 (6 decimals), you will want to set a circulating supply of 500_000_000_000_000 and set decimals to 6.

Once you've installed Python and algosdk, simply run the following command in the same directory as mint_algo.py:

```python3 mint_algo.py```
