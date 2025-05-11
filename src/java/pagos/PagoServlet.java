package pagos;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import com.stripe.param.checkout.SessionCreateParams.LineItem;
import com.stripe.param.checkout.SessionCreateParams.PaymentMethodType;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/crearPago")
public class PagoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Configurar la clave secreta de Stripe
        Stripe.apiKey = "sk_test_51R9nJU06WYalpRKDlMD5gCoqKjkmCMAD9KbE8Q7PJAKPV5ocEojiTrgjN1YcRYwAOrnsCdconUh0KpHWBNiKKwPQ00VLFYAapV";

        // Obtener los parámetros de la solicitud
        String successUrl = "http://localhost:8080/ByteShop/pagesJSP/enviarPedido.jsp";
        String cancelUrl = "http://localhost:8080/ByteShop/carrito.jsp";

        // Obtener los parámetros de la solicitud
        double total = 0;
        int idPedido = 0;
        try {
            total = Double.parseDouble(request.getParameter("total"));
            idPedido = Integer.parseInt(request.getParameter("idPedido"));
        } catch (NumberFormatException e) {
            throw new ServletException("Error con los parámetros del pago: " + e.getMessage(), e);
        }

        try {
            // Crear un LineItem (Artículo en la sesión de pago)
            LineItem lineItem = LineItem.builder()
                    .setQuantity(1L) // Solo un artículo por ahora
                    .setPriceData(
                            LineItem.PriceData.builder()
                                    .setCurrency("eur") // Moneda EUR
                                    .setUnitAmount((long) (total * 100)) // Convertir el total a centavos
                                    .setProductData(
                                            LineItem.PriceData.ProductData.builder()
                                                    .setName("Compra en ByteShop") // Nombre del producto
                                                    .build()
                                    )
                                    .build()
                    )
                    .build();

            // Crear los parámetros de la sesión de Stripe
            SessionCreateParams params = SessionCreateParams.builder()
                    .addPaymentMethodType(PaymentMethodType.CARD) // Métodos de pago (tarjetas)
                    .setMode(SessionCreateParams.Mode.PAYMENT) // Modo de pago (solo pago)
                    .setSuccessUrl(successUrl + "?idPedido=" + idPedido + "&total=" + total) // URL de éxito con el idPedido
                    .setCancelUrl(cancelUrl) // URL de cancelación
                    .addLineItem(lineItem) // Agregar el LineItem
                    .build();

            // Crear la sesión de pago con Stripe
            Session session = Session.create(params);

            // Redirigir al usuario a la URL de la sesión de pago de Stripe
            response.sendRedirect(session.getUrl());

        } catch (StripeException e) {
            // Si ocurre un error al procesar el pago, manejar la excepción
            throw new ServletException("Error al procesar el pago con Stripe: " + e.getMessage(), e);
        }
    }
}