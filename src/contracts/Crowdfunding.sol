// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    struct Project {
        uint256 id;
        address creator;
        string description;
        uint256 goal;
        uint256 duration;
        uint256 totalFunding;
        uint256 createdAt;
        bool isClosed;
        mapping(address => uint256) contributions;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(
        uint256 id,
        address creator,
        string description,
        uint256 goal,
        uint256 duration,
        uint256 createdAt
    );

    event FundAdded(uint256 projectId, address backer, uint256 amount);

    modifier onlyProjectCreator(uint256 _projectId) {
        require(
            msg.sender == projects[_projectId].creator,
            "Only the project creator can perform this action"
        );
        _;
    }

    constructor() {
        projectCount = 0;
    }

    function createProject(
        string memory _description,
        uint256 _goal,
        uint256 _duration
    ) external {
        projectCount++;
        projects[projectCount] = Project(
            projectCount,
            msg.sender,
            _description,
            _goal,
            _duration,
            0,
            block.timestamp,
            false
        );

        emit ProjectCreated(
            projectCount,
            msg.sender,
            _description,
            _goal,
            _duration,
            block.timestamp
        );
    }

    function contributeToProject(uint256 _projectId) external payable {
        require(!projects[_projectId].isClosed, "Project is closed");
        require(
            block.timestamp < projects[_projectId].createdAt + projects[_projectId].duration,
            "Project duration has ended"
        );

        projects[_projectId].contributions[msg.sender] += msg.value;
        projects[_projectId].totalFunding += msg.value;

        emit FundAdded(_projectId, msg.sender, msg.value);
    }

    function closeProject(uint256 _projectId) external onlyProjectCreator(_projectId) {
        require(
            block.timestamp >= projects[_projectId].createdAt + projects[_projectId].duration,
            "Project duration has not ended yet"
        );

        projects[_projectId].isClosed = true;
    }
    
    function auditContract() external {
        // Get the address of the deployed contract to be audited
        address contractToAudit = address(this);

        // Create an instance of the QuantstampAuditData contract
        QSPAuditData qspAuditData = new QSPAuditData();

        // Register the contract to be audited
        qspAuditData.registerContract(contractToAudit);

        // Perform the security audit
        qspAuditData.auditContract();

        // Get the audit report data
        QSPAuditReportData qspAuditReportData = QSPAuditReportData(qspAuditData.getAuditReport());

        // Access and use the audit report data as needed
        // ...
    }
}
