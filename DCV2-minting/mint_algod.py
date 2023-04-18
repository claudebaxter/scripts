from algosdk import account, transaction
from algosdk import mnemonic
from algosdk.mnemonic import from_private_key, to_private_key

from algosdk.v2client import algod

algod_token = "purestake api token (a series of numbers/letters)"
algod_address = "https://mainnet-algorand.api.purestake.io/ps2"
headers = {"X-API-Key": algod_token}
algod_client = algod.AlgodClient(algod_token, algod_address, headers)

from algosdk.v2client import algod

status = algod_client.status()

print(status)

creator_address = "algorand wallet address"
creator_mnemonic = "mnemonic passphrase just put spaces only between words"

acct_private_key = mnemonic.to_private_key(creator_mnemonic)

# Get suggested parameters
params = algod_client.suggested_params()

# Set the total supply of tokens to 500,000,000 units with 6 decimal places
total_supply = 500_000_000_000_000
decimals = 6

# Create the transaction to create the asset
txn = transaction.AssetConfigTxn(
    sender=creator_address,
    sp=params,
    default_frozen=False,
    unit_name="DCV2",  #Replace with actual unit name
    asset_name="Dark Coin",  #Replace with actual token name
    manager=creator_address, #Add manager address (and clawback/freeze/reserve if needed, otherwise will be set to false)
    url="https://dark-coin.io", #Replace with relevant website
    total=total_supply,
    decimals=decimals,
    strict_empty_address_check=False
)

# Sign the transaction with the creator's private key
signed_txn = txn.sign(acct_private_key)

# Submit the transaction to the network
txid = algod_client.send_transaction(signed_txn)

# Wait for the transaction to be confirmed
transaction.wait_for_confirmation(algod_client, txid)

# Get the asset ID of the created asset
created_asset = algod_client.pending_transaction_info(txid)["asset-index"]
print(f"Asset ID created: {created_asset}")
