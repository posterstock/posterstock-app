String html = r'''
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
    <div id="connect-button"></div>
           

  <script type="module">
   let isProgrammaticClose = false; // Флаг для отслеживания программного закрытия
   function sendDataToDart(hexAddress) {
        MessageHandler.postMessage(hexAddress);
    }
        const tonConnectUI = new TON_CONNECT_UI.TonConnectUI({
            manifestUrl: 'https://posterstock.com/tonconnect_ps.json',
            buttonRootId: 'connect-button',
                });


      tonConnectUI.onStatusChange((wallet) => {
  console.log('wallet', wallet);
                    const hexAddress = wallet.account.address;
                    sendDataToDart(hexAddress);
                      isProgrammaticClose = true; // Устанавливаем флаг перед закрытием
        tonConnectUI.closeModal();
    });
    
  const unsubscribeModal = tonConnectUI.onModalStateChange(
    (state) => {
          console.log('state', state.status);
                    console.log('state', state.status);
            if (state.status == 'closed' && !isProgrammaticClose) {
            sendDataToDart('');
        }
    });
  await tonConnectUI.openModal();
</script>
</body>
</html>
''';
