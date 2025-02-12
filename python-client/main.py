from web3 import Web3
import json

w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))

if not w3.is_connected():
    print("Failed to connect to Hardhat node")
    exit()


sender_account = w3.eth.accounts[0]

with open("../contract/artifacts/contracts/Classroom.sol/Classroom.json", "r") as f:
    contract_json = json.load(f)
    abi = contract_json["abi"]

contract_address = Web3.to_checksum_address("0xb7f8bc63bbcad18155201308c8f3540b07f84f5e")

contract = w3.eth.contract(address=contract_address, abi=abi)

owner = contract.functions.owner().call()
print("Contract Owner:", owner)

teacher_address = w3.eth.accounts[1]  # Another test account
tx = contract.functions.registerTeacher(teacher_address).transact({"from": sender_account})
w3.eth.wait_for_transaction_receipt(tx)
print(f"Teacher {teacher_address} registered successfully!")

tx = contract.functions.createProject("Blockchain 101", 1000, "Submit a smart contract").transact({"from": teacher_address})
w3.eth.wait_for_transaction_receipt(tx)
print("Project created!")

project = contract.functions.projects(1).call()
print("Project Details:", project)