# AWS Infrastructure for React Application Hosting

## **Project Overview**

This project demonstrates a robust and secure infrastructure setup for hosting a React application using AWS services, managed through Terraform. It showcases best practices in Infrastructure as Code (IaC), ensuring scalability, security, and high performance. This setup is ideal for modern web applications requiring reliable static hosting with global content delivery.

## **Key Features**

- **Scalable Static Hosting**: Utilizes Amazon S3 for storing and serving static React application files.
- **Content Delivery Network**: Leverages Amazon CloudFront to deliver content with low latency globally.
- **Security Enhancements**:
  - **Origin Access Identity (OAI)**: Restricts direct access to the S3 bucket, ensuring content is only accessible via CloudFront.
  - **Bucket Ownership Controls**: Enforces bucket ownership to prevent unauthorized access.
  - **HTTPS Enforcement**: Ensures all traffic is securely transmitted over HTTPS.
- **Automated Deployment**: Infrastructure is defined and managed using Terraform, enabling reproducibility and version control.
- **Efficient Caching**: Configured caching strategies in CloudFront to optimize performance and reduce costs.

## **Technologies Used**

- **Terraform**: Infrastructure as Code tool for provisioning and managing AWS resources.
- **AWS Services**:
  - **S3 (Simple Storage Service)**: For static website hosting.
  - **CloudFront**: As a Content Delivery Network (CDN) to distribute content globally.
  - **IAM (Identity and Access Management)**: For defining access policies and permissions.
  - **Random ID Generator**: Ensures unique S3 bucket naming to prevent conflicts.

## **Architecture Overview**

1. **S3 Bucket**: Stores the React application's build files, configured for static website hosting.
2. **CloudFront Distribution**: Distributes the content globally with caching and HTTPS support.
3. **Origin Access Identity (OAI)**: Secures the S3 bucket by allowing access only through CloudFront.
4. **Bucket Policy**: Grants CloudFront the necessary permissions to access the S3 bucket contents.
5. **Automated File Uploads**: Terraform scripts upload the React build files to S3, setting appropriate content types for each file.

## **Setup & Deployment**

### **Prerequisites**

- **Terraform**: Installed on your local machine. [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **AWS Account**: With necessary permissions to create S3 buckets, CloudFront distributions, IAM policies, etc.
- **React Application**: Built and ready for deployment.

### **Deployment Steps**

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/react-aws-infrastructure.git
   cd react-aws-infrastructure

   ```

2. **Initialize Terraform**
   terraform init

3. **Review the plan **
   terraform apply
