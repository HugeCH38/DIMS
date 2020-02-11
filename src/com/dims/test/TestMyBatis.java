package com.dims.test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.dims.domain.Drug;
import com.dims.mapper.AdminMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class TestMyBatis {
	@Autowired
	AdminMapper adminMapper;

	@Test
	public void testMyBatis() throws Exception {
		List<Drug> drugs = adminMapper.queryAllDrugs();
		for (Drug drug : drugs) {
			System.out.println(drug);
		}
	}
}
