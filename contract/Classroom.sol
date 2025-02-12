// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Classroom is ERC721, Ownable {
    uint256 public certId;
    
    enum TaskStatus { Pending, Approved, Rejected }
    
    struct Task {
        uint256 projectId;
        address student;
        string task_details;
        TaskStatus status;
    }
    
    struct Project {
        string name;
        address teacher;
        uint256 reward;
    }
    
    mapping(uint256 => Project) public projects;
    mapping(uint256 => Task) public tasks;
    mapping(address => bool) public isTeacher;
    
    uint256 public projectCount;
    uint256 public taskCount;
    
    event ProjectCreated(uint256 projectId, string name, address teacher, string task_details);
    event TaskSubmitted(uint256 taskId, uint256 projectId, address student, string task_details);
    event TaskVerified(uint256 taskId, TaskStatus status);
    
    constructor() ERC721("ACADEMIC SERTIFICATE", "ACERT") Ownable(address(this)) { }
    
    function registerTeacher(address _teacher) external onlyOwner {
        isTeacher[_teacher] = true;
    }
    
    function createProject(string memory _name, uint256 _reward, string memory _task_details) external {
        require(isTeacher[msg.sender], "Only teachers can create projects");
        projectCount++;
        projects[projectCount] = Project(_name, msg.sender, _reward);
        emit ProjectCreated(projectCount, _name, msg.sender, _task_details);
    }
    
    function submitTask(uint256 _projectId, string memory _task_details) external {
        require(projects[_projectId].teacher != address(0), "Invalid project");
        taskCount++;
        tasks[taskCount] = Task(_projectId, msg.sender, _task_details, TaskStatus.Pending);
        emit TaskSubmitted(taskCount, _projectId, msg.sender, _task_details);
    }
    
    function verifyTask(uint256 _taskId, bool _approved) external {
        Task storage task = tasks[_taskId];
        require(projects[task.projectId].teacher == msg.sender, "Only teacher can verify");
        require(task.status == TaskStatus.Pending, "Task already verified");
        
        task.status = _approved ? TaskStatus.Approved : TaskStatus.Rejected;
        emit TaskVerified(_taskId, task.status);
        
        if (_approved) {
            _mint(task.student, certId);
            certId++;
        }
    }
}
