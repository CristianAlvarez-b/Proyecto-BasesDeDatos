--Protegiendo

/*PK*/
ALTER TABLE Ventas ADD CONSTRAINT PK_Ventas PRIMARY KEY (id);
ALTER TABLE DetallesVentas ADD CONSTRAINT PK_DetallesVentas PRIMARY KEY (id, idVenta);
ALTER TABLE Generan ADD CONSTRAINT PK_Generan PRIMARY KEY (idCliente, idVenta);
ALTER TABLE SeVenden ADD CONSTRAINT PK_SeVenden PRIMARY KEY (idPerecederos, idNoPerecederos, idVenta);



/*FK*/
ALTER TABLE Ventas ADD CONSTRAINT FK_Ventas_Empleados FOREIGN KEY (idEmpleado) REFERENCES Empleados(idPersonas);
ALTER TABLE DetallesVentas ADD CONSTRAINT FK_DetallesVentas_Ventas FOREIGN KEY (idVenta) REFERENCES Ventas(id);
ALTER TABLE DetallesVentas ADD CONSTRAINT FK_DetallesVentas_Perecederos FOREIGN KEY (idPerecederos) REFERENCES Perecederos(id);
ALTER TABLE DetallesVentas ADD CONSTRAINT FK_DetallesVentas_noPerecederos FOREIGN KEY (idNoPerecederos) REFERENCES noPerecederos(id);
ALTER TABLE Generan ADD CONSTRAINT FK_Generan_Ventas FOREIGN KEY (idVenta) REFERENCES Ventas(id);
ALTER TABLE Generan ADD CONSTRAINT FK_Generan_Clientes FOREIGN KEY (idCliente) REFERENCES Clientes(idPersonas);
ALTER TABLE SeVenden ADD CONSTRAINT FK_SeVenden_Perecederos FOREIGN KEY (idPerecederos) REFERENCES Perecederos(id);
ALTER TABLE SeVenden ADD CONSTRAINT FK_SeVenden_noPerecederos FOREIGN KEY (idNoPerecederos) REFERENCES noPerecederos(id);
ALTER TABLE SeVenden ADD CONSTRAINT FK_SeVenden_Ventas FOREIGN KEY (idVenta) REFERENCES Ventas(id);


