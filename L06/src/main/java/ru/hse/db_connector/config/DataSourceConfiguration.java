package ru.hse.db_connector.config;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class DataSourceConfiguration {

    @Primary
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSourceProperties myDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Primary
    @Bean
    public DataSource trackingDataSource(DataSourceProperties myDataSourceProperties) {
        return myDataSourceProperties.initializeDataSourceBuilder().build();
    }

    @Primary
    @Bean
    public NamedParameterJdbcTemplate myNamedParameterJdbcTemplate(
            DataSource myDataSource,
            DataSourceProperties myDataSourceProperties
    ) {
        return new NamedParameterJdbcTemplate(myDataSource);
    }

}
