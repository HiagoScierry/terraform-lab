#!/bin/bash
# Atualiza os pacotes da instância
sudo apt-get update -y

# Instala o Node.js e o npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Cria o diretório para a aplicação
mkdir -p /home/ubuntu/app

# Escreve o conteúdo do index.js no arquivo, tratando o texto literalmente ✅
cat <<'EOF' > /home/ubuntu/app/index.js
${app_code}
EOF

# Escreve o conteúdo do package.json no arquivo, tratando o texto literalmente ✅
cat <<'EOF' > /home/ubuntu/app/package.json
${package_json_code}
EOF

# Muda para o diretório da aplicação
chown -R ubuntu:ubuntu /home/ubuntu/app # Garante que o usuário 'ubuntu' tem permissão
cd /home/ubuntu/app

# Instala as dependências como o usuário 'ubuntu'
sudo -u ubuntu npm install

# Inicia a aplicação em background usando nohup
sudo -u ubuntu nohup node index.js > /home/ubuntu/app/app.log 2>&1 &