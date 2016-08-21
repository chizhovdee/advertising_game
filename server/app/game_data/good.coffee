# этот файл игнорируется при считывании в gulp game data task

# товар/груз
class Good
  @types:
    industrial: 'industrial' # производственные товары
    everyday: 'everyday' # бытовые товары
    perishableFood: 'perishable_food' # скоропортящиеся продукты
    food: 'food' # продукты не требующие особых условий хранения
    bulkFood: 'bulk_food' # насыпной пищевой груз (крупа, пшено, мука и т.д.)
    bulkConstructionMaterials: 'bulk_construction_materials' # насыпные строительные материалы
    fuel: 'fuel' # горючее (бензин, нефть)
    # продолжение следует...


module.exports = Good