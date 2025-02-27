-include .env

.PHONY: build deploy fund withdraw test test-sepolia coverage deploy-sepolia

build:; forge build

deploy:
	@echo "Deploying to Anvil"
	forge script script/DeployFundMe.s.sol --rpc-url $(ANVIL_RPC_URL) --account devKey --sender $(ANVIL_SENDER_ADDRESS) --password-file .password --broadcast

fund:
	@echo "Funding on Anvil network"
	forge script script/Interactions.s.sol:FundFundMe --rpc-url $(ANVIL_RPC_URL) --account devKey --sender $(ANVIL_SENDER_ADDRESS) --password-file .password --broadcast

withdraw:
	@echo "Withdrawing on Anvil network"
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(ANVIL_RPC_URL) --account devKey --sender $(ANVIL_SENDER_ADDRESS) --password-file .password --broadcast

test:
	forge test

test-sepolia:
	forge test --fork-url $(SEPOLIA_RPC_URL)

coverage:
	forge coverage

deploy-sepolia:
	@echo "Deploying to sepolia"
	forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA_RPC_URL) --account account1-dev-web3 --sender $(SEPOLIA_SENDER_ADDRESS) --password-file .password --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv