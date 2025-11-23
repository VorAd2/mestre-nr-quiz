enum ErrorType {
  quota, // usuário deve tentar mais tarde
  network, // problema de internet
  gemini, // erro interno da IA (usuário não resolve)
  unknown, // erro no app/dart (usuário não resolve)
}
