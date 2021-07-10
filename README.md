# Fullstack Developer Coding Challenge

## Background

Utrust's mission is to deliver a trusted blockchain payment solution for the world's leading companies, ensuring payment safety for all parties.

To accomplish that mission we are building a payment gateway and API that allows merchants to easily integrate with Utrust, which will allow them to expand their customer base or permit their existing one to pay with cryptocurrencies. 

Thus, the foundation of our work is communicating and integrating with multiple crypto exchanges for exchange rates and with different blockchains so that we can have payment confirmations.

## Challenge Statement

To demonstrate your ability to work well with Utrust's tech stack and domain, please write a new Elixir Phoenix application capable of performing the following flow of tasks:

1. Have a web page that allows a user to enter an ETH transaction hash (tx_hash). This will simulate a payment throughout the challenge (Transaction Example)
2. Receive the tx_hash and treat that as a sign that payment was received
3. Perform confirmation of the payment. This can be done in a number of ways, but integrating with the Etherscan API or scrapping the specific tx_hash page are good starting points
4. Once there are at least two block confirmations of the transaction, mark the payment as complete

Other relevant points:

- There should be at least a test that exercises the submission of payment, feel free to add more
- If you want to use a frontend framework for the web portion of the challenge, please use React. That's what we use at Utrust. Using or not a frontend framework is completely up to you.
- Any styling should not use any frameworks such as Bootstrap or Foundation

## Notice

This challenge was intentionally left without limits to allow you to focus on and showcase components that you believe are valuable for such an application. That means that you are not required to complete all the tasks in order to be eligible, but we do expect a high degree of excellence in what you do completely. 

## Submission details

The whole challenge should be using only one git repository hosted on GitHub (or BitBucket if you want it to remain private). 

When you're ready to submit, send an email our way with the link to the repo, ensuring it has a proper README describing the decisions you made during the implementation.