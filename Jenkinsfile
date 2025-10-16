pipeline {
  agent any

  // =============================
  // Parámetros visibles al usuario
  // =============================
  parameters {
    // --- GCP ---
    string(name: 'GCP_PROJECT_ID', defaultValue: '', description: 'Project ID')
    string(name: 'GCP_REGION', defaultValue: '', description: 'Selecciona la región')
    string(name: 'GCP_ZONE', defaultValue: '', description: 'Selecciona la Zona')

    // --- Type ---
    choice(name: 'CPU_TYPE', choices: ['N2','C3'], description: 'tecnologia Procesador')
    choice(name: 'VM_TYPE', choices: ['e2-medium','n2-standard-4','custom'], description: 'VM Type')
    string(name: 'DISK_SIZE', defaultValue: '50', description: 'DISK_SIZE (GB)')
    choice(
      name: 'OS_TYPE',
      choices: [
        'windows-2016',
        'windows-2022',
        'windows-2025'
      ],
      description: 'Versión de Windows Server'
    )

    // --- Redes ---
    string(name: 'NETWORK_INTERFACE', defaultValue: '', description: 'Interfaz')
    string(name: 'NETWORK_SUBNET', defaultValue: '', description: 'Segmento de Red')
    choice(name: 'ENABLE_PRIVATE_IP', choices: ['yes','no'], description: 'habilitar private ip')
    string(name: 'FW_RULES', defaultValue: '', description: 'Reglas de FW (usar coma para separar)')

    // --- Policy ---
    booleanParam(name: 'CHECK_DELETE', defaultValue: false, description: 'Check delete')

    // --- Startup script ---
    string(name: 'GITCLONE_BBK', defaultValue: '', description: 'gitclone bbk (repo URL o comando)')
  }

  // =============================
  // Variable de país oculta
  // =============================
  environment {
    COUNTRY = 'Chile'  // Variable oculta, no visible en el formulario
  }

  // =============================
  // Etapas del pipeline
  // =============================
  stages {
    stage('Preparar entorno') {
      steps {
        echo "Inicializando entorno para ${params.GCP_PROJECT_ID}..."
        sh 'terraform --version'
      }
    }

    stage('Mostrar parámetros') {
      steps {
        echo "========== PARAMETROS =========="
        echo "GCP_PROJECT_ID: ${params.GCP_PROJECT_ID}"
        echo "GCP_REGION: ${params.GCP_REGION}"
        echo "GCP_ZONE: ${params.GCP_ZONE}"
        echo "CPU_TYPE: ${params.CPU_TYPE}"
        echo "VM_TYPE: ${params.VM_TYPE}"
        echo "DISK_SIZE: ${params.DISK_SIZE}"
        echo "OS_TYPE: ${params.OS_TYPE}"
        echo "NETWORK_INTERFACE: ${params.NETWORK_INTERFACE}"
        echo "NETWORK_SUBNET: ${params.NETWORK_SUBNET}"
        echo "ENABLE_PRIVATE_IP: ${params.ENABLE_PRIVATE_IP}"
        echo "FW_RULES: ${params.FW_RULES}"
        echo "CHECK_DELETE: ${params.CHECK_DELETE}"
        echo "GITCLONE_BBK: ${params.GITCLONE_BBK}"
        echo "COUNTRY (oculto): ${env.COUNTRY}"
        echo "================================"
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init -input=false
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
          terraform plan -input=false \
            -var="project_id=${GCP_PROJECT_ID}" \
            -var="region=${GCP_REGION}" \
            -var="zone=${GCP_ZONE}" \
            -var="cpu_type=${CPU_TYPE}" \
            -var="vm_type=${VM_TYPE}" \
            -var="disk_size=${DISK_SIZE}" \
            -var="os_type=${OS_TYPE}" \
            -var="network_interface=${NETWORK_INTERFACE}" \
            -var="network_subnet=${NETWORK_SUBNET}" \
            -var="enable_private_ip=${ENABLE_PRIVATE_IP}" \
            -var="fw_rules=${FW_RULES}" \
            -var="country=${COUNTRY}"
        '''
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.CHECK_DELETE == false }
      }
      steps {
        sh '''
          terraform apply -auto-approve -input=false \
            -var="project_id=${GCP_PROJECT_ID}" \
            -var="region=${GCP_REGION}" \
            -var="zone=${GCP_ZONE}" \
            -var="cpu_type=${CPU_TYPE}" \
            -var="vm_type=${VM_TYPE}" \
            -var="disk_size=${DISK_SIZE}" \
            -var="os_type=${OS_TYPE}" \
            -var="network_interface=${NETWORK_INTERFACE}" \
            -var="network_subnet=${NETWORK_SUBNET}" \
            -var="enable_private_ip=${ENABLE_PRIVATE_IP}" \
            -var="fw_rules=${FW_RULES}" \
            -var="country=${COUNTRY}"
        '''
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { return params.CHECK_DELETE == true }
      }
      steps {
        sh '''
          terraform destroy -auto-approve -input=false \
            -var="project_id=${GCP_PROJECT_ID}" \
            -var="region=${GCP_REGION}" \
            -var="zone=${GCP_ZONE}" \
            -var="cpu_type=${CPU_TYPE}" \
            -var="vm_type=${VM_TYPE}" \
            -var="disk_size=${DISK_SIZE}" \
            -var="os_type=${OS_TYPE}" \
            -var="network_interface=${NETWORK_INTERFACE}" \
            -var="network_subnet=${NETWORK_SUBNET}" \
            -var="enable_private_ip=${ENABLE_PRIVATE_IP}" \
            -var="fw_rules=${FW_RULES}" \
            -var="country=${COUNTRY}"
        '''
      }
    }
  }
}
