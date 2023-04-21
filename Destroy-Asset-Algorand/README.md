To use this script, you must install Python and Algosdk first.

### Remember that you can only delete an asset with its creator wallet, and the creator wallet must hold the entire supply for this transaction to work.

Then, read through remove_asset.py, and you will see the comments where you need to enter your Purestake API key and Purestake API URL (make sure you choose testnet or mainnet accordingly).

Then, you will need to enter your wallet address, mnemonic passphrase (separated by spaces no commas), and the ASA asset number to be destroyed.

Once everything is installed and these variables are assigned, open a terminal in the same directory (I just use the VS code terminal) and use this command to execute the script:

```python3 remove_asset.py```

# Remember to make sure you are on testnet and to doublecheck all address, mnemonic, and asset numbers to make sure you don't run this script on the wrong thing.
