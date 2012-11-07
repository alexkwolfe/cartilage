module "Cartilage.Namespaces"

test "should have view namespaces", ->
  views = {
    Foo:
      { Bar:
        { ShowView: Cartilage.Application.Views.Foo.Bar.ShowView } }
  }
  deepEqual( Cartilage.Application.Views, views)

test "view should haver reference to namespace", ->
  namespace = Cartilage.Application.Views.Foo.Bar
  view = Cartilage.Application.Views.Foo.Bar.ShowView
  deepEqual(view.namespace, namespace)
