package send;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class Correos {

    // Cambia estos valores con tus credenciales de Gmail
    private String usuario = "byteshopdaw2@gmail.com"; // Correo desde el que se enviarán los mensajes
    private String contrasena = "kcgt mcmh gemr hzdz"; // Clave de aplicación generada en Gmail

    // Método para enviar un correo
    public void enviarCorreo(String nombre, String destinatario, String asunto) {
        try {
            // Propiedades para la conexión con Gmail
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587"); // Puerto seguro para Gmail
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true"); // Activar STARTTLS para la conexión segura

            // Autenticación en Gmail
            Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(usuario, contrasena); // Autenticación con el usuario y la contraseña de la app
                }
            });

            // Cuerpo del mensaje
            String mensaje = "Estimado/a " + nombre + "," + "\n\n"
                    + "Gracias por ponerse en contacto con nosotros. Este correo electrónico es para confirmar que hemos recibido su mensaje y que nos tomamos muy en serio su preocupación." + "\n\n"
                    + "Este correo electrónico es un mensaje autogenerado para confirmar que hemos recibido su mensaje y que estamos trabajando diligentemente para responderle lo antes posible. "
                    + "Queremos asegurarnos de que su experiencia con nuestro servicio sea lo más satisfactoria posible y, por lo tanto, nos esforzamos por ofrecer una respuesta rápida y eficiente." + "\n\n"
                    + "Atentamente," + "\n"
                    + "El equipo de ByteShop";

            // Crear un mensaje MIME (Multipurpose Internet Mail Extensions)
            MimeMessage mensajeCorreo = new MimeMessage(session);
            mensajeCorreo.setFrom(new InternetAddress(usuario)); // Correo del remitente
            mensajeCorreo.addRecipient(Message.RecipientType.TO, new InternetAddress(destinatario)); // Correo del destinatario
            mensajeCorreo.setSubject(asunto, "utf-8"); // Asunto del correo
            mensajeCorreo.setText(mensaje, "utf-8"); // Cuerpo del mensaje

            // Enviar el correo utilizando el protocolo SMTP
            Transport.send(mensajeCorreo);
            System.out.println("Correo enviado correctamente a " + destinatario);
        } catch (MessagingException e) {
            System.out.println("Error al enviar el correo: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error general: " + e.getMessage());
            e.printStackTrace();
        }
    }

}
