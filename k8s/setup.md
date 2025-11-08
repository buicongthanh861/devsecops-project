eksctl create cluster --name kubernets-cluster --version 1.29 --region ap-southeast-1 --nodegroup-name linux-nodes --node-type c7i-flex.large --nodes 2
cat /root/.kube/config
kubectl create namespace devsecops
kubectl get deployments -n devsecops
kubectl get svc -n devsecops
kubectl get pods -n devsecops
eksctl delete cluster --name kubernets-cluster --region ap-southeast-1
