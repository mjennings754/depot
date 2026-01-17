require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "Acme Book",
                          description: "acme_description")
    product.image.attach(io: File.open("test/fixtures/files/box.png"),
                         filename: "box.png", content_type: "image/jpeg")

    product.price = -1
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01"],
    product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(filename, content_type)
    Product.new(
      title: "Acme book",
      description: "acme_description",
      price: 24.90
    ).tap do |product|
      product.image.attach(
        io: File.open("db/images/#{filename}"), filename:, content_type:)
    end
  end

  test "image url" do
    product = new_product("box.png", 'image/png')
    assert product.valid?, "image/png must be valid"
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:pragprog).title,
                          description: "acme_description",
                          price: 24.90)
    product.image.attach(io: File.open("test/fixtures/files/box.png"),
                        filename: "box.png", content_type: "image/png")
    assert product.invalid?
    assert_equal [ "has already been taken" ], product.errors[:title]
  end
end
