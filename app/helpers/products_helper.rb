module ProductsHelper
  def sign(product)
    product.active? ? "Delete product" : "Restore product"
  end

  def message(product)
    product.active? ? "Are you sure? Product will placed in <Inactive products>, so you can restore it later" : "You are going to restore product"
  end
end
