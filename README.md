# Restaurant Review Contract

A smart contract written in Solidity for rating restaurants on the Ethereum blockchain.

## About

Users can submit a score from 1 to 5 for a restaurant. Each Ethereum address is allowed only one review, but can update it at any time. The contract dynamically calculates the average score. The owner can update the restaurant description.

## Functions

- `submitReview(score)` —> Submit a rating from 1 to 5
- `updateReview(newScore)` —> Update your existing rating
- `averageScore()` —> Returns the average score multiplied by 100 (e.g. 425 = 4.25)
- `myReview()` —> Check your own review
- `updateDescription(newDescription)` —> Owner only can update the restaurant description
- `getInfo()` —> Returns general information about the restaurant

## Development

Developed and tested in [Remix IDE](https://remix.ethereum.org) using Solidity 0.8.x.
