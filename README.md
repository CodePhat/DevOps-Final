# Production-Grade CI/CD System (Tier 4: Docker Swarm)

**Course:** Software Deployment, Operations & Maintenance  
**Final Exam Project (50%)**  

- **Student Name:** Vũ Đình Kiệt - Vũ Tấn Minh - Lê Hoàng Phát 
- **Student ID:** 523V0011 - 523V0012 - 523V0013
- **Production URL:** https://phatminhkiet-devopsfinal.space  

---

## 1. Project Overview

This project demonstrates a **production-ready software delivery lifecycle** using **Docker Swarm–based orchestration (Tier 4)**.

The system includes:
- Automated CI/CD pipeline  
- High availability via service replication  
- Integrated security scanning  
- Full cluster observability  

### Key Features

- **Infrastructure as Code:** Provisioning with Terraform  
- **Configuration Management:** Automated setup using Ansible  
- **DevSecOps:** Security-gated pipeline with Trivy scanning  
- **High Availability:** 3-node cluster with self-healing  
- **Monitoring:** Prometheus & Grafana observability stack  

---

## 2. System Architecture

The system is deployed on **AWS** and consists of:

- **1 Manager Node (t3.small):**
  - Nginx Ingress
  - SSL Termination
  - Swarm Control Plane  

- **2 Worker Nodes (t3.small):**
  - Application replicas
  - Monitoring exporters  

- **Networking:**
  - Self-referencing Security Group for internal traffic  
  - Strict control over public ingress  

---

## 3. Tech Stack

| Component            | Technology                          |
|---------------------|------------------------------------|
| Cloud Provider      | AWS (EC2)                          |
| Infrastructure IaC  | Terraform                          |
| Configuration       | Ansible                            |
| Containerization    | Docker                             |
| Orchestration       | Docker Swarm                       |
| CI/CD               | GitHub Actions                     |
| Ingress / SSL       | Nginx + Let's Encrypt              |
| Monitoring          | Prometheus + Grafana + Node Exporter |
| Security            | Trivy                              |

---

## 4. How to Deploy (Reproducibility)

### Step 1: Provision Infrastructure

```bash
cd terraform/
terraform init
terraform apply -auto-approve
```

---

### Step 2: Configure Infrastructure

Update `ansible/inventory.ini` with the new IP addresses, then run:

```bash
cd ansible/
ansible-playbook -i inventory.ini setup_infrastructure.yml
```

---

### Step 3: Trigger CI/CD Pipeline

1. Update **GitHub Secrets**:
   - `SERVER_IP`
   - `DOCKER_HUB_TOKEN`
   - `SSH_PRIVATE_KEY`

2. Push code to the `main` branch to trigger deployment.

---

## 5. Monitoring & Dashboard Access

| Service     | URL                                              | Credentials     |
|------------|--------------------------------------------------|-----------------|
| Main App   | https://phatminhkiet-devopsfinal.space           | N/A             |
| Grafana    | http://phatminhkiet-devopsfinal.space:3001       | admin / admin   |
| Visualizer | http://phatminhkiet-devopsfinal.space:8080       | N/A             |
| Prometheus | http://phatminhkiet-devopsfinal.space:9090       | N/A             |

---

## 6. Supporting Links

- **Source Code Repository:** https://github.com/CodePhat/DevOps-Final 
- **Docker Hub Registry:** https://hub.docker.com/r/elkroenen/swarm-app  
- **Demo Video:** https://youtu.be/QDAcWKxPcrg
---

## 7. Lessons Learned & Troubleshooting

###  504 Gateway Timeouts
- **Issue:** Intermittent timeouts due to AWS Security Group restrictions  
- **Fix:** Added self-referencing rule to allow internal cluster traffic  

---

### Upstream Latency
- **Issue:** Cold-start delays in Swarm routing  
- **Fix:** Implemented `nginx proxy_next_upstream` retry logic  

---

### Vulnerability Management
- Used `.trivyignore` to document accepted risks  
- Focused on immutable NPM build-toolchain vulnerabilities in Alpine base image  
- Ensured secure delivery of application code  

---

### Vertical Scaling
- Upgraded instances from `t2.micro` → `t3.small`  
- Ensured sufficient RAM for:
  - Prometheus TSDB  
  - Grafana backend  

---

## Summary

This project successfully implements a **production-grade CI/CD pipeline** with:
- Automated infrastructure provisioning  
- Secure and scalable container orchestration  
- Real-time monitoring and observability  