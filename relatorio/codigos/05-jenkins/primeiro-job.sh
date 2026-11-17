# Passo "Executar shell" do primeiro job (projeto Freestyle "primeiro-job")
echo "Olá, Jenkins! Este é o meu primeiro job."
echo "Job: $JOB_NAME - Build número: $BUILD_NUMBER"
echo "Executado pelo usuário $(whoami) na máquina $(hostname)"
echo "Data e hora: $(date)"
java -version
git --version
