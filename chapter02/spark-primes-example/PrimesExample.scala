package com.manning.mesosinaction

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object PrimesExample {
  def isPrime(number: Int) : Boolean = {
    val sqrtOfNumber = math.sqrt(number).toInt
    val hasFactorsOtherThan1AndItself =
      (2 to sqrtOfNumber).exists { i => number % i == 0 }
    number > 1 && !hasFactorsOtherThan1AndItself
  }

  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("Spark Primes Example")
    val sc = new SparkContext(conf)

    val setSize = if (args.length > 0) args(0).toInt else 100000
    val data = 1 to setSize.toInt

    val distData = sc.parallelize(data)
    val primes = distData.filter(isPrime).collect()

    primes.foreach(Console print _ + " ")
    println

    sc.stop()
  }
}
