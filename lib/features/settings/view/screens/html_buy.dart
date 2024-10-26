String getHtmlBuy(String address, int amount) {
  return r'''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TonConnect</title>
    <style>
         html, body {
            margin: 0;  // Убираем отступы
            padding: 0; // Убираем поля
            height: 100%; // Задаем высоту 100%
            overflow: hidden; // Предотвращаем прокрутку
                background-color: black !important; 
        }
        #connect-button {
            display: none; /* Скрываем кнопку */
        }
   .modal {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        width: 100%;
        height: 100%;
        z-index: 1000;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: black; /* Устанавливаем черный фон */
    }
    </style>
    <script src="https://unpkg.com/@tonconnect/ui@latest/dist/tonconnect-ui.min.js"></script>
 
</head>
<body>
    <div id="ton-connect"></div>
    <script>
    const tonConnectUI = new TON_CONNECT_UI.TonConnectUI({
        manifestUrl: 'https://posterstock.com/tonconnect_ps.json',
        buttonRootId: 'ton-connect'
    });

    function sendDataToDart(result) {
        MessageHandler.postMessage(JSON.stringify(result));
    }

    async function connectAndSendTransaction() {
        try {
            // Подключаем кошелек
            await tonConnectUI.connectWallet();
            
            // Отправляем транзакцию
            const transaction = {
                messages: [
                    {
                        address: "''' +
      address +
      '''",
                        amount: "''' +
      amount.toString() +
      '''"
                    }
                ]
            };

            const result = await tonConnectUI.sendTransaction(transaction);
            sendDataToDart(result);
        } catch (error) {
            sendDataToDart({ error: error.message });
        } finally {
            tonConnectUI.closeModal();
        }
    }

    // Вызываем функцию подключения и отправки транзакции
    connectAndSendTransaction();
    </script>
</body>
</html>
''';
}
