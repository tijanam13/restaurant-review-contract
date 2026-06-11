// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

/// @title RestaurantReview - Smart contract for restaurant rating
/// @notice Users can rate a restaurant with a score from 1 to 5, each address only once
contract RestaurantReview {

    address public owner;
    string  public name;
    string  public description;
    uint256 public totalScore;
    uint256 public reviewCount;

    mapping(address => bool)    public hasReviewed;
    mapping(address => uint256) public reviewByUser;

    event NewReview(address indexed user, uint256 score);
    event ReviewUpdated(address indexed user, uint256 oldScore, uint256 newScore);
    event DescriptionUpdated(string newDescription);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier validScore(uint256 _score) {
        require(_score >= 1 && _score <= 5, "Score must be between 1 and 5");
        _;
    }

    /// @param _name        Restaurant name
    /// @param _description Short description of the restaurant
    constructor(string memory _name, string memory _description) {
        owner       = msg.sender;
        name        = _name;
        description = _description;
    }

    /// @notice Submit a rating from 1 to 5
    /// @param _score Rating score (1-5)
    function submitReview(uint256 _score) external validScore(_score) {
        require(!hasReviewed[msg.sender], "You have already reviewed this restaurant");

        hasReviewed[msg.sender]  = true;
        reviewByUser[msg.sender] = _score;
        totalScore              += _score;
        reviewCount             += 1;

        emit NewReview(msg.sender, _score);
    }

    /// @notice Update your existing rating
    /// @param _newScore New rating score (1-5)
    function updateReview(uint256 _newScore) external validScore(_newScore) {
        require(hasReviewed[msg.sender], "You have not reviewed this restaurant yet");

        uint256 oldScore         = reviewByUser[msg.sender];
        reviewByUser[msg.sender] = _newScore;
        totalScore               = totalScore - oldScore + _newScore;

        emit ReviewUpdated(msg.sender, oldScore, _newScore);
    }

    /// @notice Returns the average score multiplied by 100 (e.g. 425 means 4.25)
    function averageScore() external view returns (uint256) {
        if (reviewCount == 0) return 0;
        return (totalScore * 100) / reviewCount;
    }

    /// @notice Returns whether the caller has reviewed and their score
    function myReview() external view returns (bool reviewed, uint256 score) {
        reviewed = hasReviewed[msg.sender];
        score    = reviewByUser[msg.sender];
    }

    /// @notice Allows the owner to update the restaurant description
    /// @param _newDescription New description
    function updateDescription(string calldata _newDescription) external onlyOwner {
        description = _newDescription;
        emit DescriptionUpdated(_newDescription);
    }

    /// @notice Returns general information about the restaurant
    function getInfo() external view returns (
        string memory _name,
        string memory _description,
        uint256 _reviewCount,
        uint256 _averageScore
    ) {
        _name         = name;
        _description  = description;
        _reviewCount  = reviewCount;
        _averageScore = reviewCount > 0 ? (totalScore * 100) / reviewCount : 0;
    }
}
