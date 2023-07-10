# Set the Algorand API endpoint and API token
$algodApiEndpoint = "https://mainnet-algorand.api.purestake.io/idx2"
$algodApiToken = "{API token}"

# Set the account address (liquidity pool)
$accountAddress = "56XJVRGFUY5LJMUTRK4EOWOOPMW6HJI73XJVRAIFQZG5774ILJRLSOXKFM"

# Set the asset ID
$assetID = 1088771340

# Set the LP asset ID
$assetLPID = 1103290813

# Set the number of transactions to fetch
$limit = 100

# Set the request URL
$requestUrl = "$algodApiEndpoint/v2/accounts/$accountAddress/transactions?asset-id=$assetID&limit=$limit"

# Set the headers with the API token
$headers = @{
    "X-API-Key" = $algodApiToken
}

# Define total
$total = 0

# Send the HTTP request to the Algorand API
try {
    $response = Invoke-RestMethod -Uri $requestUrl -Headers $headers
    if ($response) {
        # Iterate over each transaction
        foreach ($tx in $response.transactions) {
            $round = $tx.'round-time'
            $date = ((Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($round))).AddHours(-6)
                # Set transaction result variables according to their transaction type
                if ($tx.'tx-type' -eq 'axfer') {
                    $txId = $tx.id
                    $sender = $tx.sender
                    $receiver = $tx.'asset-transfer-transaction'.receiver
                    $amount = $tx.'asset-transfer-transaction'.amount
                    $amount = $amount / 1000000
                } elseif ($tx.'tx-type' -eq 'appl' -and ($tx.'inner-txns'.'tx-type'.'asset-transfer-transaction'.'asset-id') -eq $assetLPID) {
                    $txId = $tx.id #tx.id
                    # Set transactionr results according according to payment vs. axfer transactions under the appl transaction type
                    if ($tx.'inner-txns' | where {$_.'tx-type' -eq 'axfer' -and $_.'asset-transfer-transaction'.'asset-id' -eq $assetLPID}) {
                        $tx = $tx.'inner-txns' | where {$_.'tx-type' -eq 'axfer' -and $_.'asset-transfer-transaction'.'asset-id' -eq $assetLPID} | select -last 1
                        $sender = $tx.sender
                        $receiver = $tx.'asset-transfer-transaction'.receiver
                        $amount = $tx.'asset-transfer-transaction'.amount  
                        $amount = $amount / 1000000
                    } else {
                        if ($tx.sender -eq $accountAddress) {
                            $tx = ($tx | where {$_.'inner-txns'.'tx-type' -eq 'pay' -and $_.'application-transaction'.'foreign-assets'.Contains($assetID)}).'inner-txns' | where {$_.'tx-type' -eq 'pay'}
                            $sender = $tx.sender
                            $amount = $tx.'payment-transaction'.amount
                            $receiver = $tx.'payment-transaction'.receiver
                        } else {
                            $sender = $tx.'inner-txns'.'inner-txns'.sender
                            $amount = $tx.'inner-txns'.'inner-txns'.'asset-transfer-transaction'.amount
                            $receiver = $tx.'inner-txns'.'inner-txns'.'asset-transfer-transaction'.receiver
                            $amount = $amount / 1000000
                        }
                    }       
                }

            if ($sender -eq $accountAddress) {
                $amount = $amount * -1
            }

            $total += $amount

            Write-Host "Round: $round" 
            Write-Host "Date: $date"
            Write-Host "Transaction ID: $txId"
            Write-Host "Sender: $sender"
            Write-Host "Receiver: $receiver"
            Write-Host "Amount: $amount"
            Write-Host ""
        }

        Write-Host "Highest Total: $total"

    } else {
        Write-Host "API request failed with message: $($response.message)"
        Write-Host "Response details:"
        Write-Host $response | ConvertTo-Json -Depth 10
    }
} catch {
    Write-Host "An error occurred during the API request: $_"
}
