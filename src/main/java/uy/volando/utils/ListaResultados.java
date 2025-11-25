package uy.volando.utils;

import uy.volando.soap.client.DtPaquete;
import uy.volando.soap.client.DtRuta;

//Esta lista de momento solo maneja la lista de rutas de vuelo y paquetes :D
public class ListaResultados {
    public String nombre;
    public String tipo;        // "Ruta" o "Paquete"
    public Object dato;        // DtRuta o DtPaquete original (para cuando haga click)

    public ListaResultados(String nombre, String tipo, Object dato) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.dato = dato;
    }

    // Getters (importante para EL en JSP)
    public String getNombre() {
        return nombre;
    }

    public String getTipo() {
        return tipo;
    }

    public DtRuta getRuta() {
        return (DtRuta) dato;
    }

    public DtPaquete getPaquete() {
        return (DtPaquete) dato;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setRuta(DtRuta ruta) {
        this.dato = ruta;
    }

    public void setPaquete(DtPaquete paquete) {
        this.dato = paquete;
    }
}
