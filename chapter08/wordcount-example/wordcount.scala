package com.manning.mesosinaction

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object WarAndPeaceWordCount {
  def main(args: Array[String]) {
    val basepath = if (args.length > 0) args(0) else "/tmp/warandpeace"

    val conf = new SparkConf().setAppName("War and Peace Word Count")
    val sc = new SparkContext(conf)

    val textFile = sc.textFile(s"hdfs://localhost:8020/$basepath/warandpeace.txt")

    val words = textFile.flatMap(line => line.split(" "))
    val counts = words.map(word => (word, 1)).reduceByKey(_ + _)
    counts.saveAsTextFile(s"hdfs://localhost:8020/$basepath/result")

    sc.stop()
  }
}
