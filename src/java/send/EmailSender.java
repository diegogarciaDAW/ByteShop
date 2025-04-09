package send;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailSender {

    public static void sendEmail(String toEmail, String subject, String body) throws Exception {
        // Configuración de las propiedades del servidor SMTP
        String host = "smtp.gmail.com"; // Por ejemplo, usando Gmail
        final String fromEmail = "byteshopdaw2@gmail.com"; // Tu correo electrónico
        final String password = "kcgt mcmh gemr hzdz"; // La contraseña de tu cuenta de correo

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Crear la sesión de correo
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        // Crear el mensaje de correo
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(body);

        // Enviar el correo
        Transport.send(message);
    }
}
