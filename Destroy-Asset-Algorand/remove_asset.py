from algosdk import account, transaction
from algosdk import mnemonic
from algosdk.mnemonic import from_private_key, to_private_key

from algosdk.v2client import algod

algod_token = "" #Purestake API token, log in to purestake to verify
algod_address = "https://testet-algorand.api.purestake.io/ps2" #API domain for mainnet, log in to purestake to verify (switch to test net for testing)
headers = {"X-API-Key": algod_token}
algod_client = algod.AlgodClient(algod_token, algod_address, headers)

from algosdk.v2client import algod

status = algod_client.status()

print(status)

creator_address = "" #Wallet Address
creator_mnemonic = "" #Wallet Mnemonic (just spaces no commas)
created_asset = "" #ASA number to be destroyed

acct_private_key = mnemonic.to_private_key(creator_mnemonic)

sp = algod_client.suggested_params()
# Create asset destroy transaction to destroy the asset
destroy_txn = transaction.AssetDestroyTxn(
    sender=creator_address,
    sp=sp,
    index=created_asset,
)
signed_destroy_txn = destroy_txn.sign(acct_private_key)
txid = algod_client.send_transaction(signed_destroy_txn)
print(f"Sent destroy transaction with txid: {txid}")

results = transaction.wait_for_confirmation(algod_client, txid, 4)
print(f"Result confirmed in round: {results['confirmed-round']}")

# now, trying to fetch the asset info should result in an error
try:
    info = algod_client.asset_info(created_asset)
except Exception as e:
    print("Expected Error:", e)