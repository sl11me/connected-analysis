# connected-analysis
 
## Objectif
Ce projet a pour but de mettre en place une infrastructure complète dédiée à l’analyse, l’exploitation et le conseil autour des métriques football. Il couvre la collecte, le traitement, la modélisation et la visualisation de données, ainsi que les bonnes pratiques d’infrastructure (CI/CD, IaC, observabilité) afin de servir d’exemple pédagogique de bout en bout.

## Répertoires du projet
- **data-contracts**: schémas et contrats de données (JSON Schema), conventions de stockage S3 et disposition des jeux de données.
- **docs**: documentation d’architecture, dashboards et runbooks (procédures d’ingestion, exploitation et dépannage).
- **k8s**: manifests Kubernetes organisés par bases et overlays (`dev`, `prod`) pour déployer les services (API, ingestor, processor) et la stack d’observabilité.
- **model**: code et artefacts du modèle (API de prédiction légère, dépendances, image Docker) liés aux métriques football.
- **services**:
  - **api**: service d’API (FastAPI/équivalent) exposant des endpoints pour requêter métriques et prédictions.
  - **ingestor**: ingestion et parsers (ex: fichiers VEO, tracking, sidecar vidéo) vers le lac/stream de données.
  - **processor**: traitements batch/stream, extraction de features et calcul d’indicateurs football (pipelines et schémas d’événements).
- **terraform**: Infrastructure as Code (AWS: VPC, EKS, ECR, IAM, S3/Kinesis, monitoring). Contient `envs/dev` et `envs/prod` ainsi que des modules réutilisables.
- **tools**:
  - **helm**: valeurs pour Prometheus/Grafana.
  - **scripts**: scripts d’automatisation (bootstrap EKS, kubeconfig, port-forwarding Grafana).