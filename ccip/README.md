HERE IS THE OUTPUT FROM THE CCIP DAY 3 HOMEWORK

****npx hardhat run scripts/deployment/deploySender.ts --network avalancheFuji****

Deploying Sender contract on avalancheFuji...
wait for 20 blocks
Sender contract deployed at: 0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A
Verifying Sender contract on avalancheFuji...
The contract 0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A has already been verified on Etherscan.
https://testnet.snowtrace.io/address/0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A#code
Sender contract verified on avalancheFuji!
Writing to config file: ./scripts/generatedData.json {
  ethereumSepolia: { receiver: '' },
  avalancheFuji: { sender: '0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A' }
}


****npx hardhat run scripts/deployment/deployReceiver.ts --network ethereumSepolia***

Deploying Receiver contract on ethereumSepolia...
wait for 5 blocks
Receiver contract deployed at: 0xBb8B0Bd52645fe4a52AEB1fcae0139d3a23132Bb
Verifying Receiver contract on ethereumSepolia...
The contract 0xBb8B0Bd52645fe4a52AEB1fcae0139d3a23132Bb has already been verified on Etherscan.
https://sepolia.etherscan.io/address/0xBb8B0Bd52645fe4a52AEB1fcae0139d3a23132Bb#code
Receiver contract verified on ethereumSepolia!
Writing to config file: ./scripts/generatedData.json {
  ethereumSepolia: { receiver: '0xBb8B0Bd52645fe4a52AEB1fcae0139d3a23132Bb' },
  avalancheFuji: { sender: '0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A' }
}

****npx hardhat run scripts/configuration/allowlistingForReceiver.ts --netowork ethereumSepolia****
Allowlisted: ethereumSepolia


****npx hardhat run scripts/configuration/allowlistingForReceiver.ts --network ethereumSepolia****
Allowlisted: avalancheFuji , 0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A


****npx hardhat run scripts/testing/sendCCIPMessages.ts --network avalancheFuji****
Approving 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846 for 0x491db8CE9F0B3442668d0EFB90DC1E6d55075e6A. Allowance is 115792089237316195423570985008687907853269984665640564039457584007913129639935. Signer 0x00E8f7553a7971315Bb6Fab9A6Fa4B3F9242DdB1...

Number of iterations 0 - Gas limit: 5685 - Message Id: 0x82dd1ef8ed7e3c4ed982d89262f7ee0b888ce2652db73b7341cb742a7bd92497
Number of iterations 50 - Gas limit: 16190 - Message Id: 0x455daef4a8bb4415918a4b822fae892e07c19f38bc260e4c5be2fcbfaf7a3c4e
Number of iterations 99 - Gas limit: 26485 - Message Id: 0x904035e66a159285cccb90c9d081fea3b9cc3c802b19fd9be4522ca3b75692c0