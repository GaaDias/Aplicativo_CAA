# 📱 Aplicativo CAA

Aplicativo de Comunicação Aumentativa e Alternativa para Crianças com TEA

## ✨ Descrição

**Aplicativo CAA** é uma ferramenta de comunicação alternativa voltada para crianças no espectro autista. Com uma interface amigável, permite que as crianças se comuniquem por meio de cards visuais e frases, facilitando a interação com familiares e cuidadores. O app funciona tanto online quanto offline, oferecendo uma experiência adaptativa conforme a conectividade.

## 🧩 Funcionalidades

- **Cards de Comunicação**: Visualize cards com imagens e palavras/frases para facilitar a comunicação.
- **Busca de Imagens**: Permite buscar e adicionar imagens da internet quando conectado.
- **Acesso Offline**: Salva os cards para acesso sem internet.
- **Personalização de Cards**: Adicione e personalize os cards de comunicação para se adaptar às necessidades da criança.
- **Armazenamento em Nuvem e Local**: Imagens são armazenadas no dispositivo para acesso rápido, e links em nuvem são salvos para acesso entre dispositivos.

## 🚀 Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma.
- **SQLite**: Banco de dados local para armazenamento offline de pictogramas.
- **Supabase**: Plataforma em nuvem para sincronização de dados e armazenamento de imagens, com funcionalidades de backend, como autenticação.

## 🎨 Design e Interface

A interface foi projetada para ser colorida, intuitiva e acessível para crianças e cuidadores, incluindo:

- Ícones grandes e de fácil compreensão.
- Tipografia clara e amigável.
- Navegação simplificada.

## 🖥️ Como Usar

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/GaaDias/Aplicativo_CAA.git
   cd Aplicativo_CAA
2. **Instale as dependências:**
   ```bash
   flutter pub get
3. **Configuração do Supabase:**
 - Crie um projeto no Supabase.
 - No painel do Supabase, configure um bucket para armazenar imagens e habilite a autenticação, se necessário.
 - Adicione as credenciais (URL do Supabase e chave pública) ao arquivo **``.env``** do projeto:
   ```bash
   SUPABASE_URL=<sua_url_do_supabase>
   SUPABASE_KEY=<sua_chave_publica_do_supabase>

4. **Execute o aplicativo:**
   ```bash
   flutter run

## 📂 Estrutura de Pastas

```plaintext
.
├── lib
│   ├── components    # Componentes reutilizáveis
│   ├── pages         # Telas do aplicativo
│   ├── assets        # Imagens e ícones locais
│   ├── services      # Serviços de API e funções auxiliares
│   └── utils         # Funções de suporte
├── .gitignore
├── pubspec.yaml
├── README.md
└── .env              # Arquivo de configuração com credenciais do Supabase
```

## ⚠️ Nota Importante

As instruções de uso deste README são fornecidas apenas para execução e desenvolvimento local com permissão do autor. Este projeto não possui licença, e o uso, modificação ou distribuição do código é restrito. Para solicitar autorização, entre em contato.
