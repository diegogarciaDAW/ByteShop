package entities;

import java.util.Date;
import java.util.List;

public class Pedido {

    private int codigo;
    private String estado;
    private Date fecha;
    private List<ProductoPedido> productos;

    // Getters y Setters
    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public List<ProductoPedido> getProductos() {
        return productos;
    }

    public void setProductos(List<ProductoPedido> productos) {
        this.productos = productos;
    }
}
