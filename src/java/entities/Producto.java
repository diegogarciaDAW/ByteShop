package entities;

public class Producto {
    private int id;
    private String nombre;
    private String descripcion;
    private double precio;
    private String categoria;
    private int cantidadDisponible;
    private int totalVendido;
    private String imagenBase64;

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) {
        try {
            this.nombre = new String(nombre.getBytes("ISO-8859-1"), "UTF-8");
        } catch (Exception e) {
            this.nombre = nombre;
        }
    }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) {
        try {
            this.descripcion = new String(descripcion.getBytes("ISO-8859-1"), "UTF-8");
        } catch (Exception e) {
            this.descripcion = descripcion;
        }
    }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public int getCantidadDisponible() { return cantidadDisponible; }
    public void setCantidadDisponible(int cantidadDisponible) { this.cantidadDisponible = cantidadDisponible; }

    public int getTotalVendido() { return totalVendido; }
    public void setTotalVendido(int totalVendido) { this.totalVendido = totalVendido; }

    public String getImagenBase64() { return imagenBase64; }
    public void setImagenBase64(String imagenBase64) { this.imagenBase64 = imagenBase64; }
}
