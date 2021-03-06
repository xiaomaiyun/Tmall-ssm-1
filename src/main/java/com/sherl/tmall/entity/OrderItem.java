package com.sherl.tmall.entity;

import java.io.Serializable;

public class OrderItem implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int id;
	private Product product;
	private Order order;
	private User user;
	private int number;
	private float prices;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

	public float getPrices() {
		prices = number * product.getPromotePrice();
		return prices;
	}

	public void setPrices(float prices) {
		this.prices = prices;
	}

	@Override
	public String toString() {
		return "OrderItem [id=" + id + ", product=" + product.getId() + ", number=" + number + ", prices=" + getPrices()
				+ "]";
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

}