def partsSums(xs: Vector[Int]): Vector[Int] = {
    val xsSum = xs.sum
    xs.scanLeft(xsSum)(_-_)
}
