// nodemailerライブラリを読み込む
const nodemailer = require("nodemailer");

// メール送信処理を非同期関数として定義
async function sendMail() {
  // トランスポーターを作成
  let transporter = nodemailer.createTransport({
    host: "158.217.174.41", // SMTPサーバーのアドレス
    port: 25, // SMTPサーバーのポート番号
    secure: false, // SSL/TLSを使用しない場合はfalse
    tls: {
            rejectUnauthorized: false, // セルフサイン証明書を許可
    },
  });

  // メールの内容を設定し、送信
  let info = await transporter.sendMail({
    from: 'atukunare2@gmail.com', // 送信者の名前とメールアドレス
    to: "k646592@kansai-u.ac.jp", // 受信者のメールアドレス
    subject: "テストメール", // 件名
    text: "これはテストメールです。", // 本文（プレーンテキスト）
  });

  console.log("Message sent: %s", info.messageId);
}

// メール送信処理を実行
sendMail().catch(console.error);