package com.boraji.tutorial;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @aut
 *
 */
public class MainAppTest {

   @Test
   public void testSayHello() {
      MainApp app = new MainApp();
      assertNotNull("Success", app.sayHello());
   }
}