# SOLUTION

Usually, most of the checkout solutions where payments are made using some external gateway service use to hold a reference of the external transaction on its payment local entity model, or a similar one.

That said, my first decision was that I'd need to create a migration in order to have a **payments table** in this system and, that table would have some fields to hold data extracted from the Etherscan's page, mainly the transaction hash.

## TRANSACTION VALIDATION

As suggested in the challenge statement, this could be done by using Etherscan API or even a scrapping process. Initially, to keep things simpler, I decided to move one with the API but after analysing their Transaction API, I saw I didn't have all the data I wanted on its response.

The solution was to create a custom scraper module called **UtrustTxpay.Etherscan.Scraper**.

## THE ETHERSCAN SCRAPER

Moving on with the Scraper implementation, I decided to use **HTTPoison** for requesting etherscan's page and **Floki** for parsing and extracting data from the HTML page.

The first challenge I faced was the Captcha protection. The solution I found was to implement a custom header for the HTTPoison GET request with an user-agent and a referer. That solved the problem.

Once I had all data extracted from the HTML, I decided that it'd be nice returning it as a struct, so I created the **UtrustTxpay.Etherscan.Transaction** struct.

Last but not least, after working in some refactoring I decided to extract all methods used for formatting data to its own module called **UtrustTxpay.Etherscan.Formatter**.

## CREATING THE PAYMENT

After assuming that a transaction hash is part of a payment record, before validation the transaction I needed actually to create a payment. So, I decided to create a form for receiving the transaction hash and persisting in the database a new payment with that hash.

I needed to implement the frontend interface.

## THE FRONTEND

I wanted to validate ASAP what I had decided and built so far so I decided to take advantage of the great Live View from Phoenix.

I created a **/payments** route in charge of loading this new **PaymentsLiveView** page.

I wanted some nice look and feel for this simple page so I decided to design an UI using Figma. You can see the original design in [https://bit.ly/3yI4YWN](https://bit.ly/3yI4YWN). It was implemented within the application using Tailwind CSS in order to speed up the development.

<img src="https://raw.githubusercontent.com/paulofabiano/utrust_txpay/main/assets/static/images/utrust-txpay.png?token=AAGASISYZLAWFCDLEVOPJLDA5HWBG" />

This page has two sections: The first one is the form where we can create a new payment and, the second one, is a simple list of all payments created.

## THE WHOLE FLOW

Once we input the transaction hash and submit the form, a new payment is recorded and a **UtrustTxpay.PubSub** message is broadcasted. This allows all open page instances to be updated in real-time for all users.

The **PaymentsLiveView** is responsible for handling this broadcasted message and requesting the Scraper to fetch transaction's data. The responsability of handling the new record's persistance and validating the transaction were splitted. 

If the blocks confirmations returned from the scraper is higher than 1, the payment's status is updated to **confirmed**, otherwise it remains as **pending**. Those pending payments can be checked again by clicking the **Verify transaction again** button within its container, which also contains a button for deleting each payment.

## DEPENDENCIES

- Elixir 1.12.0
- Erlang/OTP 22

## RUNNING THE APPLICATION

Make sure you have Elixir and Erlang installed and then execute `mix deps.get` in order to fetch all dependencies from the application.

Once it's done, run `mix phx.server` within the project's root folder and access *http://localhost:4000/payments*.

## RUNNING THE TESTS

Simply run `mix test` from the project's root folder.

## TODO

- Create docker and docker-compose implementations to make it easier to run the application not concerning about previous setups;
- Improve testing coverage;
- Using OTP for implementing a supervisor tree for auto validating transactions from all pending payments without any action from the user;





