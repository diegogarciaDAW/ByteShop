package entities;

public class ProductoPedido {

    private String nombre;
    private int cantidad;

    public ProductoPedido(String nombre, int cantidad) {
        this.nombre = nombre;
        this.cantidad = cantidad;
    }

    public String getNombre() {
        return nombre;
    }

    public int getCantidad() {
        return cantidad;
    }
}
